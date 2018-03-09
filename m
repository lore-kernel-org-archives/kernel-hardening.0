Date: Fri, 9 Mar 2018 23:57:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH][RFC] rslib: Remove VLAs by setting upper bound on
 nroots
In-Reply-To: <CAGXu5j+hySkn5dHpKeRAf8NBm6p+iWDG+eVqs_HGDmu2naTdTw@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1803092356210.1570@nanos.tec.linutronix.de>
References: <20180309144613.GA48965@beast> <alpine.DEB.2.21.1803091610120.1364@nanos.tec.linutronix.de> <CAGXu5j+hySkn5dHpKeRAf8NBm6p+iWDG+eVqs_HGDmu2naTdTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 9 Mar 2018, Kees Cook wrote:
> On Fri, Mar 9, 2018 at 7:49 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Fri, 9 Mar 2018, Kees Cook wrote:
> 
> Maybe I should just go with 24 as the max, and if we have a case where
> we need more, address it then?

Works for me.

Thanks,

	tglx
