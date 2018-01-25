Date: Thu, 25 Jan 2018 13:34:33 +0000
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20180125133433.3a750f25@alans-desktop>
In-Reply-To: <20180125120401.30596-1-Jason@zx2c4.com>
References: <20180125120401.30596-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] cpu: do not leak vulnerabilities to unprivileged users
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 25 Jan 2018 13:04:01 +0100
"Jason A. Donenfeld" <Jason@zx2c4.com> wrote:

> While it's public information if the CPU in general has spectre/meltdown
> bugs, it probably shouldn't be as globally obvious to all unprivileged
> users whether or not the kernel is doing something to mitigate

There are plenty of cases where it is useful for an application such as a
JIT to know what level of protection it needs to be providing. For
example if you look across the ecosystem (notably ARM) a lot of common
slower processors are not vulnerable. For those a JIT would want to
generate code without the overhead of any protections.

As you observe any attacker can already trivially ascertain whether
protection is on, so there is no point pretending file permissions
magically stop that. In fact the information is already in cpuinfo.

IMHO given it's trivially available info and useful for JITs it make
sense for the data to be exposed.

Alan
