import fs from 'node:fs';

// Read a file piped in from stdin
export function read_stdin() {
	try {
		const file = fs.readFileSync(0, 'utf-8');
		return file;
	} catch {
		return "";
	}
}
