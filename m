Date: Fri, 26 Jan 2018 16:43:10 +0000
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20180126164310.13a29ad2@alans-desktop>
In-Reply-To: <20180126123158.9575-1-Jason@zx2c4.com>
References: <CAHmME9p7QdAZf2NR4fkheRFVUoH1a27rmRcOnzkSS+nE5gJ63Q@mail.gmail.com>
	<20180126123158.9575-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2] cpu: do not leak vulnerabilities to unprivileged
 users
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 26 Jan 2018 13:31:58 +0100
"Jason A. Donenfeld" <Jason@zx2c4.com> wrote:

> While it's public information if the CPU in general has spectre/meltdown
> bugs, it probably shouldn't be as globally obvious to all unprivileged
> users 

As I replied to you last time you posted this

a) The info is already trivially accessible via /proc/cpuinfo or by
measurement to an attacker
b) Some JIT and other environments need to know

Alan
