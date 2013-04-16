Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <516D9525.9060600@zytor.com>
Date: Tue, 16 Apr 2013 11:15:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1365797627-20874-1-git-send-email-keescook@chromium.org> <CAGXu5jKjR46sZ4XnfzaJ0daNC82bqY2wdbTZn05Wz3v5hkP5BA@mail.gmail.com>
In-Reply-To: <CAGXu5jKjR46sZ4XnfzaJ0daNC82bqY2wdbTZn05Wz3v5hkP5BA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 0/6] kernel ASLR
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/16/2013 11:08 AM, Kees Cook wrote:
> On Fri, Apr 12, 2013 at 1:13 PM, Kees Cook <keescook@chromium.org> wrote:
>> This splits up the relocs tool changes into the separate logical pieces,
>> which should be easier to review. I could use some suggestions on a
>> better way to build it in the 4th patch. What I have now seems ugly,
>> but Kbuild would not give me its secrets.
> 
> How does the relocation portion of this series look? It's separate
> from the ASLR logic, but required for it. Do those changes look good
> for the tip/kaslr tree?
> 

They are probably okay... I should take a closer look.

I might prioritize it down since (a) I am sick, and (b) it is the week
before the merge window.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
