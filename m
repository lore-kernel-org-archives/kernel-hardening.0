MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <94D018AF-07C3-47BE-9C62-4B2923D3E39B@zytor.com>
References: <20170329203908.GA39222@beast> <ea0a7663-7318-6086-1cb8-25fd9a252f83@zytor.com>
 <CAGXu5jLQfS6gK2MyetWPjyJDOg8NdACXsPXLt7OasQE03VUwPg@mail.gmail.com>
 <CA+55aFxGEQroSYmSgEQefNUhJfmvMRg8XAy3TrtYoiLwUQNwKA@mail.gmail.com>
 <CALCETrVudF5-buAHqGd3y1g8X3mnf6tmB5Av50k9WFL-yrbZmQ@mail.gmail.com>
 <CA+55aFyVxvzyHxAx4Wik=FtKLJLFxa12kbuS+3KatLU+ysM7Cg@mail.gmail.com> <94D018AF-07C3-47BE-9C62-4B2923D3E39B@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Mar 2017 16:56:32 -0700
Message-ID: <CA+55aFx508viAhC_JqNnN0KvvoFDWrDZX3TXutDQRpdzWpegNw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] x86/fpu: move FPU state into separate cache
To: Peter Anvin <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, Thomas Garnier <thgarnie@google.com>, Brian Gerst <brgerst@gmail.com>, He Chen <he.chen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Fenghua Yu <fenghua.yu@intel.com>, Piotr Luc <piotr.luc@intel.com>, Kyle Huey <me@kylehuey.com>, Len Brown <len.brown@intel.com>, KVM <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 29, 2017 at 3:28 PM,  <hpa@zytor.com> wrote:
> On March 29, 2017 2:41:00 PM PDT, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> An alternative is to wrap the randomized structure inside a nonrandomized wrapper structure.

That's probably a reasonable alternative. Making "struct task_struct"
be something that contains a fixed beginning and end, and just have an
unnamed randomized part in the middle might be the way to go.

Something like

    struct task_struct {
        struct thread_info thread_info;

        /* Critical scheduling state goes here */
        /* .. keep it all in one cacheline */

       struct randomized_task_struct {
            this is where the "I don't care" stuff goes..
       };

        /* CPU-specific state of this task: */
        struct thread_struct            thread;

        /*
         * WARNING: on x86, 'thread_struct' contains a variable-sized
         * structure.  It *MUST* be at the end of 'task_struct'.
         *
         * Do not put anything below here!
         */
    };

would randomize the bulk of it but leave some core stuff at fixed places.

Note that the whole concept of randomized structure member ordering is
largely security theater. It makes different distributions have
different offsets, but practically speaking

 (a) you'll be able to match up offsets with "uname -r", so it's a
slight inconvenience and mostly useless for big distros that would be
common targets (or common IoT targets or whatever)

 (b) any distro that supports some binary modules (which includes a
lot of Android stuff, for example) will have serious problems and
likely turn it off

so it's imnsho a pretty questionable security thing. It's likely most
useful for one-off "special secure installations" than mass
productions.

So I seriously believe that it's useful mainly *only* if it's really
simple and convenient (for both distributions and developers), and
once we have to play games to work around it, I think that's a strong
signal that we shouldn't bother.

                      Linus
