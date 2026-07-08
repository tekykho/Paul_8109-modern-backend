const { readFile } = require('node:fs/promises');
const { PDFParse } = require('pdf-parse');
const { ai, MODEL } = require('./gemini');

// all embeddings must use back the same model
const EMBEDDING_MODEL = 'gemini-embedding-001';

async function chunkPDF(filePath, chunkSize = 1000, overlap = 200) {

    // read the file into a buffer
    const buffer = await readFile(filePath);

    // grab all the entire text from the PDF file
    const parser = new PDFParse({ data: buffer });
    const result = await parser.getText();
    await parser.destroy();
    // fullText will have all the text of the PDF
    const fullText = result.text;

    const chunks = [];
    let startIndex = 0;
    let chunkOrder = 0;

    while (startIndex < fullText.length) {
        const endIndex = Math.min(startIndex + chunkSize, fullText.length);
        let chunkText = fullText.substring(startIndex, endIndex);

        if (endIndex < fullText.length) {
            // remeber the last period or breakpoint
            const lastPeriod = chunkText.lastIndexOf('.');
            const lastNewline = chunkText.lastIndexOf('\n');
            const breakPoint = Math.max(lastPeriod, lastNewline);

            if (breakPoint > chunkSize * 0.5) {
                chunkText = chunkText.substring(0, breakPoint + 1);
                startIndex += breakPoint + 1;
            } else {
                startIndex += chunkSize;
            }
        } else {
            startIndex = fullText.length;
        }

        chunks.push({
            text: chunkText.trim(),
            order: chunkOrder++,
            startChar: startIndex - chunkText.length,
            endChar: startIndex
        });

        if (startIndex < fullText.length) {
            startIndex -= overlap;
        }
    }

    return chunks;

}

async function generateEmbedding(text) {
    const response = await ai.models.embedContent({
        model: EMBEDDING_MODEL,
        contents: text,
        config: {
            outputDimensionality: 768
        }
    })

    return response.embeddings[0].values;
}

async function answerQuestion(question, pdfId, connection) {
    const questionEmbedding = await generateEmbedding(question);
    const vectorString = `[${questionEmbedding}]`;

    // find all the chunks that are relevant to the user's quesiton
    const [relevantChunks] = await connection.execute(`
        SELECT chunk_text, VEC_DISTANCE(embedding, VEC_FromText(?)) as distance
        FROM PDFChunks
        WHERE pdf_id = ?
        ORDER BY distance ASC
        LIMIT 5
    `, [vectorString, pdfId]);

    if (relevantChunks.length === 0) {
        return "I do not have enough information to answer this question"
    }
    
    let context = "";
    for (let chunk of relevantChunks) {
        context += chunk.chunk_text + "\n\n";
    }

    const prompt = `You are a helpful financial product assistant. Answer the user's question based on the following information from the product documentation.

Context from product documentation:
${context}

User question: ${question}

Instructions:
- Answer based ONLY on the provided context
- If it possible to infer from the context, with some additional thinking, the answer to the user's question, tell the user that
  your guess based on general assumption (i.e, you are less confidence)
- if you need to answer outside from the context, then be clear that you are not referring to the attached context
- Be concise and helpful
- Cite specific details from the context when possible
- Explain in ELI5 terms
`

    const response = await ai.models.generateContent({
        model: MODEL,
        contents: prompt
    })

    return response.text;

}

module.exports = {
    generateEmbedding, chunkPDF, answerQuestion
}