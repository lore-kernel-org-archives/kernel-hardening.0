Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <87wpoie6oj.fsf@x220.int.ebiederm.org>
References: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
	<1459281207-24377-2-git-send-email-sbauer@eng.utah.edu>
	<87wpoie6oj.fsf@x220.int.ebiederm.org>
Date: Thu, 31 Mar 2016 17:00:24 -0500
Message-ID: <CA+55aFy1nzw0amBKYD6SfS6-4tiCDfX7viUBHFEq-9Kzv_-Mtg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 1/4] SROP Mitigation: Architecture independent code for
 signal cookies
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Scott Bauer <sbauer@eng.utah.edu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, the arch/x86 maintainers <x86@kernel.org>, Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, wmealing@redhat.com, Abhiram Balasubramanian <abhiram@cs.utah.edu>, Scott Bauer <sbauer@plzdonthack.me>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 31, 2016 at 3:25 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> I suspect we want this to be a per-mm attribute rather than a per-thread
> attribute.
>
> Otherwise you are breaking anything that uses a N-M threading model.
> Which I suspect means that this implementation choice breaks all go
> programs on linux.

That sounds like a good point, but wouldn't it make more conceptual
sense to make it part of "struct sighand_struct" instead?

That is also shared for threads.

                Linus
