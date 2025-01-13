import util from "util";
import stream from "stream";
import { Readable } from "stream";

const pipeline = util.promisify(stream.pipeline);

export const handler = awslambda.streamifyResponse(
  async (event, responseStream, _context) => {
    const requestStream = Readable.from(
      Buffer.from(JSON.stringify({ message: "Hello World" }))
    );
    await pipeline(requestStream, responseStream);
  }
);
