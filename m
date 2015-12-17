Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41A361EA@IRSMSX102.ger.corp.intel.com>
References: <2236FBA76BA1254E88B949DDB74E612B41A361EA@IRSMSX102.ger.corp.intel.com>
Date: Thu, 17 Dec 2015 12:25:40 -0800
Message-ID: <CAGXu5j+pt1x9AntHM3Z4O8V=5-So0tWj=9aoJ-kP1q0p3-s=Vw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Introduction and task request
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 16, 2015 at 1:34 AM, Reshetova, Elena
<elena.reshetova@intel.com> wrote:
> Hi everyone,
>
>
> I would like to introduce myself: I am part of Intel Open Source Technology
> Security team and I got lucky enough to have part of my time now allocated
> to this project now, so I am happy to start helping.

Hi! Welcome to the project! :)

> What would be the reasonable task for me to do?

I always suggest people work on stuff that interests them. Do you have
any specific areas you like working on, or exploits you'd like to see
stopped?

> I am quite a newbie in proper kernel development work (but not a newbie in
> platform security), so please as initial task do not through to me the
> biggest dead animal out there with the task to revive it.

Heh, understood. We'll be happy to assist you through whatever parts
you might want help with.

> It is going to be a learning exercise for me at least at the beginning, but
> I am hoping to learn fast and start bringing value to the project.

I had mentioned PAX_USERCOPY earlier. I'm not sure how much work
that'll be, but extracting it would be the first step, and you can go
from there. There's no one actively working on it at the moment, and
it would be very nice to have.

There's also the need to improve the kernel's module loader to segment
memory into rx, ro, and rw, in support of the __ro_after_init work. I
or Emese will likely get around to that, but it can probably be done
in parallel.

Or perhaps looking into the prior BPF_HARDEN work (currently this just
disables eBPF, but it used to try to defend against trivial
heap-sprays).

Thanks for joining! :)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
