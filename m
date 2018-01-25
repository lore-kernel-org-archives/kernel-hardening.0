MIME-Version: 1.0
In-Reply-To: <20180125133433.3a750f25@alans-desktop>
References: <20180125120401.30596-1-Jason@zx2c4.com> <20180125133433.3a750f25@alans-desktop>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu, 25 Jan 2018 14:40:03 +0100
Message-ID: <CAHmME9p7QdAZf2NR4fkheRFVUoH1a27rmRcOnzkSS+nE5gJ63Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH] cpu: do not leak vulnerabilities
 to unprivileged users
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 25, 2018 at 2:34 PM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
> As you observe any attacker can already trivially ascertain whether
> protection is on, so there is no point pretending file permissions
> magically stop that. In fact the information is already in cpuinfo.

Actually the other place it leaks is in dmesg, which would need to be
patched too.

My understanding about cpuinfo was that it showed whether or not the
processor family is generally vulnerable to it, independent of whether
or not the kernel has been patched. What this patch does relates to
whether or not the kernel has been patched.
