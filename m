Date: Mon, 2 Apr 2018 11:04:58 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] gpio: fix ifnullfree.cocci warnings
In-Reply-To: <20180402083150.GA8013@wunner.de>
Message-ID: <alpine.DEB.2.20.1804021102370.3198@hadrien>
References: <alpine.DEB.2.20.1803300829580.2870@hadrien> <20180402083150.GA8013@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Lukas Wunner <lukas@wunner.de>
Cc: Laura Abbott <labbott@redhat.com>, Linus Walleij <linus.walleij@linaro.org>, kbuild-all@01.org, Kees Cook <keescook@chromium.org>, linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Andy Shevchenko <andy.shevchenko@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>



On Mon, 2 Apr 2018, Lukas Wunner wrote:

> On Fri, Mar 30, 2018 at 08:32:56AM +0200, Julia Lawall wrote:
> > --- a/drivers/gpio/gpiolib.c
> > +++ b/drivers/gpio/gpiolib.c
> > @@ -2774,8 +2773,7 @@ int gpiod_get_array_value_complex(bool r
> >  			trace_gpio_value(desc_to_gpio(desc), 1, value);
> >  		}
> >
> > -		if (slowpath)
> > -			kfree(slowpath);
> > +		kfree(slowpath);
> >  	}
> >  	return 0;
> >  }
> > @@ -3020,8 +3018,7 @@ int gpiod_set_array_value_complex(bool r
> >  		if (count != 0)
> >  			gpio_chip_set_multiple(chip, mask, bits);
> >
> > -		if (slowpath)
> > -			kfree(slowpath);
> > +		kfree(slowpath);
> >  	}
> >  	return 0;
> >  }
>
> The problem I see here is that kfree may not be in L1 cache,
> and in that case checking for non-NULL locally in this function
> should actually be cheaper.
>
> Note that kfree() need only be called in the slowpath, which
> is the *unlikely* case.  Letting the branch predictor assume
> that kfree() is not called is the right thing to do here.
>
> The function is a hot path, on the Revolution Pi open source PLCs
> we're calling it every 250 usec to poll digital inputs and update
> digital outputs.
>
> Would "if (unlikely(slowpath))" be sufficient to make coccinelle
> happy?  That's what I'd suggest then.

I think that indeed it would not complain any more in this case.  But at
least from kbuild, you shouldn't get another report on this, even if you
don't change it.  Of course, someone else running the script could find
the issue again.  If it would seem appropriate to you, adding a comment
would also at least capture the knowledge that the change is not wanted.

julia

>
> Otherwise "if (unlikely(chip->ngpio > FASTPATH_NGPIO))" could be used,
> though that might be minimally slower due to the pointer chasing.
>
>
> > @@ -2758,8 +2758,7 @@ int gpiod_get_array_value_complex(bool r
> >
> >  		ret = gpio_chip_get_multiple(chip, mask, bits);
> >  		if (ret) {
> > -			if (slowpath)
> > -				kfree(slowpath);
> > +			kfree(slowpath);
> >  			return ret;
> >  		}
> >
>
> This particular change on the other hand is fine because the kfree()
> is occurring in an error path, which we'll normally not enter anyway.
>
> Thanks,
>
> Lukas
>
