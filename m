MIME-Version: 1.0
In-Reply-To: <20180126164310.13a29ad2@alans-desktop>
References: <CAHmME9p7QdAZf2NR4fkheRFVUoH1a27rmRcOnzkSS+nE5gJ63Q@mail.gmail.com>
 <20180126123158.9575-1-Jason@zx2c4.com> <20180126164310.13a29ad2@alans-desktop>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri, 26 Jan 2018 18:47:28 +0100
Message-ID: <CAHmME9poivOgtCkOs5cjQXT0qxayk7MV2QLUBYhoUrKu=VUhuA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v2] cpu: do not leak
 vulnerabilities to unprivileged users
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 26, 2018 at 5:43 PM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
> a) The info is already trivially accessible via /proc/cpuinfo

No, /proc/cpuinfo shows if the CPU itself has these bugs, but doesn't
show whether or not the kernel has gone to lengths to mitigate these
bugs.

# grep -o 'bugs.*cpu_meltdown' -m1 /proc/cpuinfo
bugs            : cpu_meltdown
# cat /sys/devices/system/cpu/vulnerabilities/meltdown
Mitigation: PTI

> or by measurement to an attacker

Right, so without this, an attacker has to measure. The purpose of
this patchset is to require the attacker to perform an additional
measurement. That seems worthwhile, especially if measurements are or
would ever become non-trivial to make.

> b) Some JIT and other environments need to know

Shouldn't JITs do the best they can with the environment they're in?
And for that, isn't /proc/cpuinfo enough?

Jason
