Date: Thu, 24 Jan 2019 16:15:00 +1300
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [RFC v1 0/4] static analysis of copy_to_user()
Message-ID: <20190124031500.GA22711@cisco>
References: <20181220195931.20331-1-tycho@tycho.ws>
 <20181221224717.zixqkz26xujllmq4@ltop.local>
 <20190120190510.GC3987@cisco>
 <20190121214127.t3opb6cffaz4ibp5@ltop.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190121214127.t3opb6cffaz4ibp5@ltop.local>
To: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Luc,

On Mon, Jan 21, 2019 at 10:41:28PM +0100, Luc Van Oostenryck wrote:
> On Mon, Jan 21, 2019 at 08:05:10AM +1300, Tycho Andersen wrote:
> > Hey Luc,
> > 
> > On Fri, Dec 21, 2018 at 11:47:19PM +0100, Luc Van Oostenryck wrote:
> > > On Thu, Dec 20, 2018 at 12:59:27PM -0700, Tycho Andersen wrote:
> > > > Hi all,
> > > > 
> > > > A while ago I talked with various people about whether some static
> > > > analsys of copy_to_user() could be productive in finding infoleaks.
> > > > Unfortunately, due to the various issues outlined in the patch notes, it
> > > > doesn't seem like it is. Perhaps these checks are useful to put in just
> > > > to future proof ourselves against these sorts of issues, though.
> > > > 
> > > > Anyway, here's the code. Thoughts welcome!
> > > 
> > > Hi,
> > > 
> > > I'm taking the first patch directly but I won't be able to look
> > > closer at the other patches until next week.
> > 
> > Any chance you can take a peek at these?
> 
> Hi,
> 
> Sorry, I've had few available time the last weeks.
> I had look at them shortly after you send them but
> I haven't yet made my mind about them.
> 
> I'm quite reluctant to add complexity (the AST walking)
> if it doesn't bring much benefit if any.

No problem :).

> In, short the problems are:
> 1) duplication of the AST walking
> 2) unreliable type because of using void *
> 3) unreliable size because array to pointer degeneracy
> 
> There is some solutions, though:
> 1) what *could* be done is to add a method 'check'
>    to struct symbol_op and call it, *for example*,
>    just after op->expand() in expand_symbol_call()
>    (and add a mechanism to set this method for the symbol
>    corresponding to copy_to_user()).
> 
>    Otherwise, splitting the AST walking from sparse.c
>    and making it something generic would be preferable.

Yeah, this sounds like a good option to me.

>    Another approach could be keep the check via OP_CALL
>    but doing it just after linearization, before the
>    optimization destroy the types (and add, if needed,
>    some flag to force linearize_cast() keep absolutely
>    all type info).
> 
> 2) this one seems pretty hopeless

I was hoping you might have some brilliant insight here. It seems like
these checks could catch real bugs at some point, so I'll give the
changes you've suggested a go over the next couple of weeks and see
about a v2.

> 3) the current calls degenerate()/create_pointer()
>    do indeed destroy the original type and (at first sight)
>    no 'addressof' should exist anymore after evaluation.
>    This is inconsistent with the existence of expand_addressof().
>    By changing degenerate()/create_pointer() the original
>    type should stay available.

Ah ha, thanks. I guess it's not necessary to change create_pointer()
for this, but degenerate() definitely looks important.

Thanks!

Tycho
