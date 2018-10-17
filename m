Date: Wed, 17 Oct 2018 08:42:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] seq_buf: Make seq_buf_puts() NULL terminate the buffer
Message-ID: <20181017084228.725dd349@gandalf.local.home>
In-Reply-To: <CAG48ez2W8HeJcuPwA25vSqTco3B=CRzycSA0=--pG=7jWi3pPw@mail.gmail.com>
References: <20181017121000.30240-1-mpe@ellerman.id.au>
	<CAG48ez2W8HeJcuPwA25vSqTco3B=CRzycSA0=--pG=7jWi3pPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Jann Horn <jannh@google.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 17 Oct 2018 14:26:37 +0200
Jann Horn <jannh@google.com> wrote:

> > diff --git a/lib/seq_buf.c b/lib/seq_buf.c
> > index 11f2ae0f9099..b1570204cde3 100644
> > --- a/lib/seq_buf.c
> > +++ b/lib/seq_buf.c
> > @@ -144,9 +144,13 @@ int seq_buf_puts(struct seq_buf *s, const char *str)
> >
> >         WARN_ON(s->size == 0);
> >
> > +       /* Add 1 to len for the trailing NULL which must be there */  
> 
> Nit: In the comments, I would prefer either "null byte" or "NUL"
> instead of "NULL" when talking about something that is not a pointer.
> 
> > +       len += 1;  
> 
> It looks like you're using an "unsigned int" for the length, meaning
> that this can in theory (e.g. when operating on a string from a big
> vmalloc buffer) overflow. You should be using size_t here.

seq_buf is not meant for gigabytes of data. We'll change it when that
ever happens.

-- Steve


> 
> >         if (seq_buf_can_fit(s, len)) {
> >                 memcpy(s->buffer + s->len, str, len);
> > -               s->len += len;
> > +               /* Don't count the trailing NULL against the capacity */
> > +               s->len += len - 1;
> >                 return 0;
> >         }
> >         seq_buf_set_overflow(s);
> > --
> > 2.17.1
> >  
