MIME-Version: 1.0
References: <20190329081358.30497-1-elena.reshetova@intel.com>
 <CAGXu5jKH3js8pOv726jQ84rycd04OcwosN9-OkJg7UnsMMiuxA@mail.gmail.com> <2236FBA76BA1254E88B949DDB74E612BA4C3BA7F@IRSMSX102.ger.corp.intel.com>
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612BA4C3BA7F@IRSMSX102.ger.corp.intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 4 Apr 2019 10:03:58 -0700
Message-ID: <CAGXu5j+05tZUOuka2YQy+5WPvVwHBrM-YEeto1iLzz2shCnANQ@mail.gmail.com>
Subject: Re: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon syscall
Content-Type: text/plain; charset="UTF-8"
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@amacapital.net>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jannh@google.com>, "Perla, Enrico" <enrico.perla@intel.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 4, 2019 at 4:41 AM Reshetova, Elena
<elena.reshetova@intel.com> wrote:
> What I still don't fully understand here (due to my little knowledge of
> compilers) and afraid of is that the asm code that alloca generates (see my version)
> and the alignment might differ on the different targets, etc.

I guess it's possible, but for x86_64, since appears to be consistent.

> If you tried it on yours, can you send me the asm code that it produced for you?
> Is it different from mine?

You can compare compiler outputs here. Here's gcc vs clang for this code:
https://godbolt.org/z/WJSbN8
You can adjust compiler versions, etc.

-- 
Kees Cook
