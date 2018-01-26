MIME-Version: 1.0
In-Reply-To: <CAHmME9poivOgtCkOs5cjQXT0qxayk7MV2QLUBYhoUrKu=VUhuA@mail.gmail.com>
References: <CAHmME9p7QdAZf2NR4fkheRFVUoH1a27rmRcOnzkSS+nE5gJ63Q@mail.gmail.com>
 <20180126123158.9575-1-Jason@zx2c4.com> <20180126164310.13a29ad2@alans-desktop>
 <CAHmME9poivOgtCkOs5cjQXT0qxayk7MV2QLUBYhoUrKu=VUhuA@mail.gmail.com>
From: Boris Lukashev <blukashev@sempervictus.com>
Date: Fri, 26 Jan 2018 13:45:03 -0500
Message-ID: <CAFUG7CdjTPeH5nAr_BaEB2ixETT8PosbnvhXBvuP01UOXjqFLQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v2] cpu: do not leak
 vulnerabilities to unprivileged users
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 26, 2018 at 12:47 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> On Fri, Jan 26, 2018 at 5:43 PM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
>> a) The info is already trivially accessible via /proc/cpuinfo
>
> No, /proc/cpuinfo shows if the CPU itself has these bugs, but doesn't
> show whether or not the kernel has gone to lengths to mitigate these
> bugs.
>
> # grep -o 'bugs.*cpu_meltdown' -m1 /proc/cpuinfo
> bugs            : cpu_meltdown
> # cat /sys/devices/system/cpu/vulnerabilities/meltdown
> Mitigation: PTI
>
>> or by measurement to an attacker
>
> Right, so without this, an attacker has to measure. The purpose of
> this patchset is to require the attacker to perform an additional
> measurement. That seems worthwhile, especially if measurements are or
> would ever become non-trivial to make.
>
>> b) Some JIT and other environments need to know
>
> Shouldn't JITs do the best they can with the environment they're in?

In an ideal world, anything using JIT would have a graceful fail-down
to pre-compiled generic paths. As we've seen with PaX' MPROTECT
killing half of the desktop environment along with third party
(browsers/editors/etc) applications, and pretty much every interpreter
or FFI binding-compiled-binary; there's a lot of JIT
compilation/execution out there which doesnt take failure well. I'm
not saying that this would be as detrimental, but in cases where the
JIT gets confused and does "the wrong thing," all sorts of undefined
behaviors might occur ranging from poorly performing execution to
security concerns and crashes. _If_ such confusion is possible, is the
benefit of a layer of concealment (as opposed to cover) worth the
potential effort in tracking down problems which could be caused by
this? How likely are users to bypass the constraint by running as root
and expose their system to more threat?

> And for that, isn't /proc/cpuinfo enough?
>
> Jason



-- 
Boris Lukashev
Systems Architect
Semper Victus
