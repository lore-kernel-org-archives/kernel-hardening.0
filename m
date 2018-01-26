MIME-Version: 1.0
In-Reply-To: <20180126164310.13a29ad2@alans-desktop>
References: <CAHmME9p7QdAZf2NR4fkheRFVUoH1a27rmRcOnzkSS+nE5gJ63Q@mail.gmail.com>
 <20180126123158.9575-1-Jason@zx2c4.com> <20180126164310.13a29ad2@alans-desktop>
From: Boris Lukashev <blukashev@sempervictus.com>
Date: Fri, 26 Jan 2018 12:23:15 -0500
Message-ID: <CAFUG7CeFDq1rRAZRfqUc0dP=2bRH-OjPBw0-BHqiXSoJypGWGQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v2] cpu: do not leak
 vulnerabilities to unprivileged users
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Greg KH <gregkh@linuxfoundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

This sort of seems like painting a plate carrier onto a tshirt.
Attackers will know, one way or another, as we have illegitimate and
legitimate vectors for gaining information. Good ecosystem inhabitants
however will be in the dark because this proposes to obfuscate their
legitimate interfaces used to determine execution context.
This might be a better option for namespaces - run an NS with
"hardware spectre mitigation masking" when the consumers in it can
handle that, but leave the rest of the userspace only as broken as it
was before. Without additional protections, bad guys can still glean
the info via leaks and functional testing, but it should provide a
small hurdle without sacrificing JIT ops in the primary NS.

-Boris

On Fri, Jan 26, 2018 at 11:43 AM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
> On Fri, 26 Jan 2018 13:31:58 +0100
> "Jason A. Donenfeld" <Jason@zx2c4.com> wrote:
>
>> While it's public information if the CPU in general has spectre/meltdown
>> bugs, it probably shouldn't be as globally obvious to all unprivileged
>> users
>
> As I replied to you last time you posted this
>
> a) The info is already trivially accessible via /proc/cpuinfo or by
> measurement to an attacker
> b) Some JIT and other environments need to know
>
> Alan



-- 
Boris Lukashev
Systems Architect
Semper Victus
