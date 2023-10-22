import argparse
import time
from datetime import datetime

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
    print(f"parameter:")
    print(f"  url: {url}")
    print(f"  dauer: {duration} sekunden")
    print(f"  datei: {filename}")
    print(f"  block-größe: {blocksize} bytes")

    stream = requests.get(url, stream=True)

    bitrate = int(stream.headers.get('icy-br'))
    samplerate = int(stream.headers.get('icy-samplerate'))
    name = stream.headers.get('icy-name')
    url = stream.headers.get('icy-url')
    desc = stream.headers.get('icy-description')
    genre = stream.headers.get('icy-genre')

    print(f"metadaten:")
    print(f"  bitrate: {bitrate}")
    print(f"  samplerate: {samplerate}")
    print(f"  name: {name}")
    print(f"  beschreibung: {desc}")
    print(f"  genre: {genre}")

    if stream.status_code != 200:
        print("fehler beim aufzeichnen")
        exit(1)

    start = time.time()
    
    with open(filename, 'wb') as file:
        for chunk in stream.iter_content(chunk_size=blocksize):
            if chunk:
                file.write(chunk)

            if (time.time() - start) >= duration:
                break

    date = datetime.now()
    audio = AudioSegment.from_file(filename, format='mp3')
    audio = audio[:(duration * 1000)]
    audio.export(filename, format="mp3", tags={
        'title': f"{name} – {date.strftime('%Y-%m-%d %H:%M:%S')}",
        'description': desc,
        'genre': genre,
        'url': url,
        'artist': name,
        'album': name,
        'year': date.strftime('%Y'),
    })

if __name__ == "__main__":
    main()
