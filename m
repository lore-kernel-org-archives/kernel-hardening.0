MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1706121929430.1911@nanos>
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
 <1497286620-15027-9-git-send-email-s.mesoraca16@gmail.com> <alpine.DEB.2.20.1706121929430.1911@nanos>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 13 Jun 2017 09:41:29 +0200
Message-ID: <CAJHCu1K00Xx=2ZqXjmRxp-8dze7HGtiN6cFvP4mTWapr3jSkRQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 08/11] Creation of "pagefault_handler_x86" LSM hook
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

2017-06-12 19:32 GMT+02:00 Thomas Gleixner <tglx@linutronix.de>:
> That explains, what you could do with it, but it completely lacks any
> rationale WHY this is desired and good behaviour and how that is a security
> feature.

You are right, I could have been more descriptive.
This is not a security feature "per se", it's a way to soften some
unwanted side-effects of restrictive security features.
In particular I'm trying to introduce a feature that will prevent
the runtime creation of executable code in user-space programs:
it's something like the PaX's MPROTECT feature.
This hook is used to implement what PaX call "trampoline
emulation" that, in practice, allow for some specific code
sequences to be executed even if they are in non executable memory.
This may look like a bad thing at first, but you have to consider
that:
- This allows for "memory restriction" features to stay on even
  when they should be turned off. And, even if this emulation
  makes the feature less effective, it's still better than having
  it turned off completely
- The only code sequences emulated are trampolines used to make
  function calls. In many cases, when you have the chance to
  make arbitrary memory writes, you can already manipulate the
  control flow of the program by overwriting function pointers or
  return values. So, in many cases, the "trampoline emulation"
  doesn't introduce new exploit vectors.
- It's a feature that can be turned on only if needed, on a per
  executable file basis.

Thank your for taking the time to review this.
