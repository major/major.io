---
aktt_notify_twitter:
- false
aliases:
- /2010/06/27/modern-implementation-and-explanation-of-linux-virtual-server-lvs/
author: Major Hayden
date: 2010-06-27 16:03:27
tags:
- general advice
- high availability
- linux
- networking
- performance
- sysadmin
- web
title: A modern implementation and explanation of Linux Virtual Server (LVS)
---

![/wp-content/uploads/2010/06/loadbalancer-viaproxy.png](/wp-content/uploads/2010/06/loadbalancer-viaproxy.png) Typical configuration for a proxy-type load balancer

A typical load balancing configuration using hardware devices or software implementations will be organized such that they resemble the diagram at the right. I usually call this a proxy-type load balancing solution since the load balancer proxies your request to some other nodes. The standard order of operations looks like this:

* client makes a request
* load balancer receives the request
* load balancer sends request to a web node
* the web server sends content back to the load balancer
* the load balancer responds to the client

If you're not familiar with load balancing, here's an analogy. Consider a fast food restaurant. When you walk up to the counter and place an order, you're asking the person at the counter (the load balancer) for a hamburger. The person at the counter is going to submit your order, and then a group of people (web nodes) are going to work on it. Once your hamburger (web request) is ready, your order will be given to the person at the counter and then back to you.

This style of organization can become a problem as your web nodes begin to scale. It requires you to ensure that your load balancers can keep up with the requests and sustain higher transfer rates that come from having more web nodes serving a greater number of requests. Imagine the fast food restaurant where you have one person taking the orders but you have 30 people working on the food. The person at the counter may be able to take orders very quickly, but they may not be able to keep up with the orders coming out of the kitchen.

![/wp-content/uploads/2010/06/loadbalancer-ipvs.png](/wp-content/uploads/2010/06/loadbalancer-ipvs.png) LVS allows for application servers<br /> to respond to clients directly

This is where [Linux Virtual Server (LVS)][1] really shines. LVS operates a bit differently:

* client makes a request
* load balancer receives the request
* load balancer sends request to a web node
* the web server sends the response **directly to the client**

The key difference is that the load balancer sends the unaltered request to the web server and the web server responds _directly to the client_. Here's the fast food analogy again. If you ask the person at the counter (the load balancer) for a hamburger, that person is going to take your order and give it to the kitchen staff (the web nodes) to work on it. This time around, the person at the counter is going to advise the kitchen staff that the order needs to go directly to you once it's complete. When your hamburger is ready, a member of the kitchen staff will walk to the counter and give it directly to you.

In the fast food analogy, what are the benefits? As the number of orders and kitchen staff increases, the job of the person at the counter doesn't drastically increase in difficulty. While that person will have to handle more orders and keep tabs on which of the kitchen staff is working on the least amount of orders, they don't have to worry about returning food to customers. Also, the kitchen staff doesn't need to waste time handing orders to the person at the counter. Instead, they can pass these orders directly to the customer that ordered them.

In the world of servers, this is a large benefit. Since the web servers' responses no longer pass through the load balancer, they can spend more time on what they do best: balancing traffic. This allows for smaller, lower-powered load balancing servers from the beginning. It also allows for increases in web nodes without big changes for the load balancers.

There are three main implementations of LVS to consider:

![2]

**LVS-DR: Direct Routing**

The load balancer receives the request and sends the packet directly to a waiting real server to process. LVS-DR has the best performance, but all of your servers must be on the same network subnet and they have to be able to share the same router (with no other routing devices in between them).

**LVS-TUN: Tunneling**

This is very similar to the direct routing approach, but the packets are [encapsulated][3] and sent directly to the real servers once the load balancer receives them. This removes the restriction that all of the devices must be on the same network. Thanks to encapsulation, you can use this method to load balance between multiple datacenters.

**LVS-NAT: Network Address Translation**

Using NAT for LVS yields the least performance and scaling of all of the implementation options. In this configuration, the incoming requests are rewritten so that they will be transported correctly in a NAT environment. This puts a bigger burden on the load balancer as it must rewrite the requests quickly while still keeping up with how much work is being done by each web server.

* * *

**Looking for a Linux Virtual Server HOWTO?** Stay tuned. I'm preparing one for my next post.</p>

 [1]: http://en.wikipedia.org/wiki/Linux_Virtual_Server
 [2]: /wp-content/uploads/2010/06/Lvslogo.png
 [3]: http://en.wikipedia.org/wiki/IP_tunnel