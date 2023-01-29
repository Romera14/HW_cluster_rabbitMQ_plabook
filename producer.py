#!/usr/bin/env python
# coding=utf-8
import pika

connection = pika.BlockingConnection(pika.URLParameters('amqp://admin:admin@51.250.8.175:5672'))
channel = connection.channel()
channel.queue_declare(queue='hello')
channel.basic_publish(exchange='', routing_key='hello', body='Hello Netology!')
connection.close()