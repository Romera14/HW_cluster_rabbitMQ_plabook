#!/usr/bin/env python
# coding=utf-8
import pika

connection = pika.BlockingConnection(pika.URLParameters('amqp://admin:admin@51.250.90.255:5672'))
channel = connection.channel()
channel.queue_declare(queue='hello')

def callback(ch, method, properties, body):
    print(" [x] Received %r" % body)

channel.basic_consume(queue='hello', on_message_callback=callback, auto_ack=True)

channel.start_consuming()
connection.close()