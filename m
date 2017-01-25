MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAEk6tExvL7NCB8P-YP7MwT6Ysi8S08H+RgsvBfRXp336noTfxg@mail.gmail.com>
References: <CAEk6tExvL7NCB8P-YP7MwT6Ysi8S08H+RgsvBfRXp336noTfxg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 25 Jan 2017 11:37:13 -0800
Message-ID: <CAGXu5j+KYYRvWC1MmMyn3w1N5DsXeAnHR3wZvjpUfUaqd3L2Rw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Introduction
To: Jessica Frazelle <me@jessfraz.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 23, 2017 at 4:06 PM, Jessica Frazelle <me@jessfraz.com> wrote:
> I've been lurking on this mailing list for over a year now, so I think
> I understand the gist of how it works. I am looking for some ways to
> help out in my free time.

Greetings! Thanks for saying "hi". :)

> The subsystems I know the most about are cgroups and namespaces. I
> previously was a maintainer of Docker (I added the seccomp integration
> and maintained the AppArmor bits) and now I work on kubernetes.
>
> Let me know if you think there is a good place to start!

I've mostly been trying to keep track of kernel self-protection TODO
items, so I haven't been keeping too up to date on userspace-support
things that the kernel provides. I know Solar has a list of things
he'd like to see, and I know there was an earlier attempt at building
an LSM to provide a more hardened chroot implementation (that Elena
sent a version of last year).

Are there any gaps in existing cgroups/namespaces stuff that you'd
like to see fixed? Or are there any areas of self-protection work that
you find interesting and would want to learn more about?

-Kees

-- 
Kees Cook
Nexus Security
