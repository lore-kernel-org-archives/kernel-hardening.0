Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGbJS05ue0qc1GxBQf5oCnYu2=WC7Eeq1uR0jQYWmGJLe7pZFQ@mail.gmail.com>
References: <CAGbJS05ue0qc1GxBQf5oCnYu2=WC7Eeq1uR0jQYWmGJLe7pZFQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 16 Dec 2016 10:58:41 -0800
Message-ID: <CAGXu5jKW+fo38ZqNt8u8oW4igY6uRpyfLvU_wD9Aq2zzP0ZVig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Working on lib/test_bpf.c tests for eBPF
 constant blinding
To: Sandra Escandor-O'Keefe <rvonflugel@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Daniel Borkmann <daniel@iogearbox.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Dec 16, 2016 at 9:13 AM, Sandra Escandor-O'Keefe
<rvonflugel@gmail.com> wrote:
> I'm interested in starting on a bit of linux kernel development, and also
> contributing to something security related for the kernel. I was looking at
> the projects listed in the TODO of
> https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project and "Write
> lib/test_bpf.c tests for eBPF constant blinding" caught my eye. Is this
> something that still needs to be done? If so, is there someone specific that
> I can reach out to in order to get some guidance on where to start?

Hi! Welcome to the fun. :)

I've added Elena and Daniel to CC, who both worked on the blinding.
The goal would be to add some kind of test that inserted constants in
eBPF instructions and then verified they were gone in the resulting
eBPF JIT kernel code. Until now, it's only been done manually, and
it'd be nice to have a test that could show if there were regressions
or if an architecture didn't support the blinding in its JIT.

For some background on the blinding, I wrote a short description of it here:
https://outflux.net/blog/archives/2016/10/03/security-things-in-linux-v4-7/

Let me know if that helps get you to a starting point! :)

-Kees

-- 
Kees Cook
Nexus Security
