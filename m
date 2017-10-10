Message-ID: <1507619375.3552.28.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Tue, 10 Oct 2017 00:09:35 -0700
In-Reply-To: <1507517945-27155-1-git-send-email-me@tobin.cc>
References: <1507517945-27155-1-git-send-email-me@tobin.cc>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] lib/vsprintf: add default case to 'i' specifier
To: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 2017-10-09 at 13:59 +1100, Tobin C. Harding wrote:
> %pi leaks kernel addresses if incorrectly specified.

Are there any uses that are incorrectly specified?
grep doesn't show any.

> Currently the printk specifier %pi (%pI) contains a switch statement
> without a default clause. The %pi specifier requires a subsequent
> character (4, 6, or S) controlling the output. If the specifier is
> incomplete the switch statement will fall through and print the variable
> argument address in hex instead of the value of the argument (as an IP
> address).
> 
> If uncaught this leaks kernel addresses into dmesg. We can return an
> error string to make the bug visible and stop addresses leaking.
> 
> Add a default clause returning an error string, stops leaking addresses
> and makes the buggy code
[]
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -1775,6 +1775,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  			default:
>  				return string(buf, end, "(invalid address)", spec);
>  			}}
> +		default:
> +			return string(buf, end, "(invalid specifier, form: %pi4)", spec);
>  		}
>  		break;
>  	case 'E':

I'm not sure this is a big deal and
maybe a better way to handle it is to
move the %pK, case 'K': block and add
a fallthrough or keep the case 'K':
block where it is and add a goto.
