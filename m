MIME-Version: 1.0
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com>
 <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
 <20190208130544.GI32511@hirez.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612BA4BB7580@IRSMSX102.ger.corp.intel.com>
 <20190208142642.GJ32511@hirez.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612BA4BB96C5@IRSMSX102.ger.corp.intel.com>
 <CALCETrXA8PBtu6B5z5gjJV4X_pe16f4DE7T5o5AspgMckBRWKA@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612BA4BBA73C@IRSMSX102.ger.corp.intel.com>
 <EBF96DB2-B25D-437B-A067-F187E031BC3E@amacapital.net> <5E269FBC3009974381A340959F3135C95C8F78E5@hasmsx108.ger.corp.intel.com>
 <CAGXu5jJSWf=CAij3_dxA9+n6+fWtt1MOT3dWD07vdkhrfC8bpQ@mail.gmail.com> <CAGXu5j+833Rv5dnsNth522WGirAjysipPo2gecSX2HC5y-MkUg@mail.gmail.com>
In-Reply-To: <CAGXu5j+833Rv5dnsNth522WGirAjysipPo2gecSX2HC5y-MkUg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 21 Feb 2019 15:29:39 -0800
Message-ID: <CAGXu5jL=uPyP=eG296oTixkto83LqVyasvo9qaNEn2P6bAtufQ@mail.gmail.com>
Subject: Re: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon
 system call
Content-Type: text/plain; charset="UTF-8"
To: "Perla, Enrico" <enrico.perla@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>, "Reshetova, Elena" <elena.reshetova@intel.com>, Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Peter Zijlstra <peterz@infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "tytso@mit.edu" <tytso@mit.edu>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 20, 2019 at 2:53 PM Kees Cook <keescook@chromium.org> wrote:
> BTW, the attack that inspired grsecurity's RANDKSTACK is described in
> these slides (lots of steps, see slide 79):
> https://www.slideshare.net/scovetta/stackjacking

Sorry, as PaX Team reminded me, I misremembered this. RANDKSTACK
already existed. It was STACKLEAK that was created in response to this
particular attack. I still think this attack is worth understanding to
see what hoops must be jumped through when dealing with stack
randomization (and other defenses).

-- 
Kees Cook
