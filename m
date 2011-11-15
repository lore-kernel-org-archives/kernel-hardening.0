Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 15 Nov 2011 16:53:33 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111115125332.GA8486@albatros>
References: <20111115112151.GA3002@albatros>
 <CAM_iQpUAqDmP571R3NkYOmPC7yAEMaHTFmmQCm5hLUXV5Fh8xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM_iQpUAqDmP571R3NkYOmPC7yAEMaHTFmmQCm5hLUXV5Fh8xQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC 1/3] procfs: parse mount options
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Greg KH <greg@kroah.com>, Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Américo,

On Tue, Nov 15, 2011 at 19:48 +0800, Américo Wang wrote:
> On Tue, Nov 15, 2011 at 7:21 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> > +
> > +static int proc_parse_options(char *options, struct pid_namespace *pid)
> > +{
> > +       char *p;
> > +       substring_t args[MAX_OPT_ARGS];
> > +       int option;
> 
> 
> 'option' is unused?

Right.

> > +               switch (token) {
> > +               default:
> 
> 
> This switch block reads odd...

It will be used in 2/3 patch.

> > +                       pr_err("proc: unrecognized mount option \"%s\" "
> > +                              "or missing value", p);
> 
> "\n" is needed.

Correct.  Thank you!

> > +                       return 0;
> > +               }
> > +       }
> > +
> > +       return 1;
> > +}

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
