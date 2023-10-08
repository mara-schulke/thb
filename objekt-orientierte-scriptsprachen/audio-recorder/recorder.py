import argparse
import time

import requests
from pydub import AudioSegment


def main():
    parser = argparse.ArgumentParser(description="Audiorecorder CLI")
    parser.add_argument("url", help="URL des Streams")
    parser.add_argument("--filename", default="myRadio", help="Name der aufgezeichneten Datei")
    parser.add_argument("--duration", type=int, default=30, help="Aufnahmedauer in Sekunden")
    parser.add_argument("--blocksize", type=int, default=64, help="Blockgröße beim Lesen/Schreiben in Bytes")
    
    args = parser.parse_args()
    record_mp3_stream(args.url, args.filename, args.duration, args.blocksize)


def record_mp3_stream(url, filename, duration, blocksize):
    print(f"Recording audio from {url} to {filename} for {duration} seconds with block size {blocksize}.")

    stream = requests.get(url, stream=True)
    start = time.time()

    bitrate = int(stream.headers.get('icy-br'))
    samplerate = int(stream.headers.get('icy-samplerate'))
    name = stream.headers.get('icy-name')
    url = stream.headers.get('icy-url')
    desc = stream.headers.get('icy-description')
    genre = stream.headers.get('icy-genre')

    print(bitrate, name, url, desc, genre)
    

    print(stream.headers)

    audio = AudioSegment.empty()

    for chunk in stream.iter_content(chunk_size=blocksize):
        print(len(audio), len(chunk))
        
        if int(audio.duration_seconds) >= int(duration):
            break

        if chunk:
            audio.raw_data += bytes(chunk)

    # convert audio
    # audio = audio[:duration * 1000]
    print(audio.duration_seconds, len(audio), audio.frame_rate)
    audio.export(filename, format="mp3")
    
    print(f"Die Aufnahme wurde unter {filename} gespeichert.")


if __name__ == "__main__":
    main()
