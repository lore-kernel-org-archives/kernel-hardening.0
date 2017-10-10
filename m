Date: Wed, 11 Oct 2017 08:47:42 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171010214742.GA9359@eros>
References: <1507517945-27155-1-git-send-email-me@tobin.cc>
 <1507619375.3552.28.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1507619375.3552.28.camel@perches.com>
Subject: [kernel-hardening] Re: [PATCH] lib/vsprintf: add default case to 'i' specifier
To: Joe Perches <joe@perches.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 10, 2017 at 12:09:35AM -0700, Joe Perches wrote:
> On Mon, 2017-10-09 at 13:59 +1100, Tobin C. Harding wrote:
> > %pi leaks kernel addresses if incorrectly specified.
> 
> Are there any uses that are incorrectly specified?
> grep doesn't show any.

You are correct I don't see any. 

> > Currently the printk specifier %pi (%pI) contains a switch statement
> > without a default clause. The %pi specifier requires a subsequent
> > character (4, 6, or S) controlling the output. If the specifier is
> > incomplete the switch statement will fall through and print the variable
> > argument address in hex instead of the value of the argument (as an IP
> > address).
> > 
> > If uncaught this leaks kernel addresses into dmesg. We can return an
> > error string to make the bug visible and stop addresses leaking.
> > 
> > Add a default clause returning an error string, stops leaking addresses
> > and makes the buggy code
> []
> > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> []
> > @@ -1775,6 +1775,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
> >  			default:
> >  				return string(buf, end, "(invalid address)", spec);
> >  			}}
> > +		default:
> > +			return string(buf, end, "(invalid specifier, form: %pi4)", spec);
> >  		}
> >  		break;
> >  	case 'E':
> 
> I'm not sure this is a big deal and
> maybe a better way to handle it is to
> move the %pK, case 'K': block and add
> a fallthrough or keep the case 'K':
> block where it is and add a goto.

Thanks for suggestions.

Tobin.
