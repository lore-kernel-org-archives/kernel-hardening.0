Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1457470075-4586-1-git-send-email-sbauer@eng.utah.edu>
References: <1457470075-4586-1-git-send-email-sbauer@eng.utah.edu>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 8 Mar 2016 12:58:59 -0800
Message-ID: <CALCETrVLyg3CJHoFORnmJ+_0WirKck=unBQ8Zu2JUd+WhF6C5g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 1/3] SROP Mitigation: Architecture independent code for
 signal cookies
To: Scott Bauer <sbauer@eng.utah.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>, wmealing@redhat.com, Andi Kleen <ak@linux.intel.com>, Abhiram Balasubramanian <abhiram@cs.utah.edu>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 8, 2016 at 12:47 PM, Scott Bauer <sbauer@eng.utah.edu> wrote:
> This patch adds a per-process secret to the task struct which
> will be used during signal delivery and during a sigreturn.
> Also, logic is added in signal.c to generate, place, extract,
> clear and verify the signal cookie.
>

Potentially silly question: it's been a while since I read the SROP
paper, but would the technique be effectively mitigated if sigreturn
were to zero out the whole signal frame before returning to user mode?
