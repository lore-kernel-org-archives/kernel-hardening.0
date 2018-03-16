Date: Fri, 16 Mar 2018 20:18:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v5 0/2] Remove false-positive VLAs when using max()
Message-ID: <20180316201803.GH30522@ZenIV.linux.org.uk>
References: <1521174359-46392-1-git-send-email-keescook@chromium.org>
 <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com>
 <CA+55aFx92dXg-qnrjGS2Rsna6TE5HSPBgGpSA3cv4n_n3RqBzA@mail.gmail.com>
 <20180316175502.GE30522@ZenIV.linux.org.uk>
 <CA+55aFzsrVF7W+YQye=EeF4Wk3yDOTbb_vSiM8s1zkKbE4JV4Q@mail.gmail.com>
 <20180316201215.GG30522@ZenIV.linux.org.uk>
 <CA+55aFwxWEWya44pVAxSLM8oH8NyrOVf8QfLowSnX4WUXvC0xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwxWEWya44pVAxSLM8oH8NyrOVf8QfLowSnX4WUXvC0xg@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Florian Weimer <fweimer@redhat.com>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input <linux-input@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 16, 2018 at 01:15:27PM -0700, Linus Torvalds wrote:
> On Fri, Mar 16, 2018 at 1:12 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > That's C99, straight from N1256.pdf (C99-TC3)...
> 
> I checked C90, since the error is
> 
>    ISO C90 forbids variable length array
> 
> and I didn't see anything there.

Well, yes - VLA are new in C99; C90 never had those...
