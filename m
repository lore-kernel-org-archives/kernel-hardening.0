Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Wed, 22 Feb 2017 07:34:15 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170222063415.GA27700@gmail.com>
References: <20170214194259.75960-1-thgarnie@google.com>
 <CAJcbSZESdSQncHeKNVzHO90W7UJUKxKGy-h+rM82OhBc-Nh=cg@mail.gmail.com>
 <CALMp9eQAZchjpgmqP1=qj-FXka8+Xbwqiu3xDz9KoLQ60nh-UQ@mail.gmail.com>
 <CAJcbSZEkqFPVNzygmAjkyxNssZxnJTYBYuMbvjms+3ZGcCY_sQ@mail.gmail.com>
 <CALCETrV4JqVfHQhz4EuFKfHXK=zABsmwZpgz4ijz89O8v4GdfA@mail.gmail.com>
 <CAJcbSZHh+q-hSk9XHZuEfE9VWUTdNZHFEbf68=Qk4uPhB2jhoQ@mail.gmail.com>
 <CAJcbSZEPHBK5FfbU5uorQVkpVbENG0ZBdiA=acJ10rqtLn+TwQ@mail.gmail.com>
 <20170221080332.GB3125@gmail.com>
 <211929849.24027362.1487672898147.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <211929849.24027362.1487672898147.JavaMail.zimbra@redhat.com>
Subject: [kernel-hardening] Re: [PATCH v3 4/4] KVM: VMX: Simplify segment_base
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Garnier <thgarnie@google.com>, Andy Lutomirski <luto@amacapital.net>, Jim Mattson <jmattson@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Paul Gortmaker <paul.gortmaker@windriver.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Christian Borntraeger <borntraeger@de.ibm.com>, "Luis R . Rodriguez" <mcgrof@kernel.org>, He Chen <he.chen@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, Stanislaw Gruszka <sgruszka@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Adam Buchbinder <adam.buchbinder@gmail.com>, Dave Hansen <dave.hansen@intel.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>, Joerg Roedel <joro@8bytes.org>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>, Linux PM list <linux-pm@vger.kernel.org>, linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, lguest@lists.ozlabs.org, kvm list <kvm@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Paolo Bonzini <pbonzini@redhat.com> wrote:

> > Paolo, how stable, non-rebasing are the KVM tree commits?
> 
> Whatever ends in linux-next is stable.  I have a separate rebasing branch,
> but it's not part of linux-next by design.

Ok, that's nice!

> > Or should we keep Andy's KVM patches together with the GDT patches? Either 
> > workflow works for me - it's your call as these are predominantly KVM changes.
> 
> I'll delay my pull request to Linus a couple days so that I can test Andy's 6 
> patches. Then you can just base your branch on Linus's tree.

Fantastic, thank you!

	Ingo
