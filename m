Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Wed, 02 Mar 2016 22:33:20 +0100
MIME-Version: 1.0
Message-ID: <56D75C20.3969.4578E077@pageexec.freemail.hu>
In-reply-to: <CAGXu5j+_3g-DAucJz+CYLZPEUauqfy52FmFDquh4xPOGB3Ek1g@mail.gmail.com>
References: <20160301181400.9c623ee9230381da90b89b2a@gmail.com>, <20160301181514.dc3dadeb7e18b77a09dddb7f@gmail.com>, <CAGXu5j+_3g-DAucJz+CYLZPEUauqfy52FmFDquh4xPOGB3Ek1g@mail.gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH v4 1/3] GCC plugin infrastructure
To: Emese Revfy <re.emese@gmail.com>, Kees Cook <keescook@chromium.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michal Marek <mmarek@suse.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 1 Mar 2016 at 14:50, Kees Cook wrote:

> > @@ -124,5 +159,37 @@ quiet_cmd_host-cxxobjs     = HOSTCXX $@
> >  $(host-cxxobjs): $(obj)/%.o: $(src)/%.cc FORCE
> >         $(call if_changed_dep,host-cxxobjs)
> >
> > +# Compile .c file, create position independent .o file
> > +# host-cshobjs -> .o
> > +quiet_cmd_host-cshobjs = HOSTCC  -fPIC $@
> 
> Is there a reason to include the -fPIC and -shared (below) in the
> "quiet" output?

this is how it used to be before the entire .so building infrastructure
was nuked from the upstream kernel some time last year IIRC, i only kept
it alive as it was in PaX. i guess the quiet command was more verbose to
make it easier to spot shared objects during make which at the time were
built as dependencies only, not as primary targets (as is the case now
with the gcc plugins). in any case, this is just a visual clue and i don't
particularly care about the color of this bikeshed :).
