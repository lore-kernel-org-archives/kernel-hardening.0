Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <1459281207-24377-2-git-send-email-sbauer@eng.utah.edu>
References: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
	<1459281207-24377-2-git-send-email-sbauer@eng.utah.edu>
Date: Tue, 29 Mar 2016 18:04:22 -0500
Message-ID: <CA+55aFy=3kDv98O-R-JLhQhdDBb+2kMjZDRsLd=_t8n9sKT7yQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 1/4] SROP Mitigation: Architecture independent code for
 signal cookies
To: Scott Bauer <sbauer@eng.utah.edu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, the arch/x86 maintainers <x86@kernel.org>, Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, wmealing@redhat.com, Abhiram Balasubramanian <abhiram@cs.utah.edu>, Scott Bauer <sbauer@plzdonthack.me>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 29, 2016 at 2:53 PM, Scott Bauer <sbauer@eng.utah.edu> wrote:
> @@ -1231,6 +1232,8 @@ void setup_new_exec(struct linux_binprm * bprm)
>         /* This is the point of no return */
>         current->sas_ss_sp = current->sas_ss_size = 0;
>
> +       get_random_bytes(&current->sig_cookie, sizeof(current->sig_cookie));
> +

This should probably just be

     current->sig_cookie = get_random_long();

instead. That will use hardware random numbers if available, and be
*much* faster.

I realize that some people don't like the hardware random number
generators because they don't trust them, but quite frankly, for
something like this it's fine. If the attacker is in collusion with
the hardware manufacturer, you have way bigger problems than a SROP
attack.

                 Linus
