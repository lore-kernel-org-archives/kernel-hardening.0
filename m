MIME-Version: 1.0
In-Reply-To: <f6c8b2c4-965c-7f8e-bfff-36b63e6f87fb@schaufler-ca.com>
References: <CAFwXZv_b3hdEA4xOFKqAVfc4UZEBX=dL9DOY_mDHExsW+Qg6tQ@mail.gmail.com>
 <f6c8b2c4-965c-7f8e-bfff-36b63e6f87fb@schaufler-ca.com>
From: Lukas Odzioba <lukas.odzioba@gmail.com>
Date: Thu, 25 May 2017 01:05:29 +0200
Message-ID: <CABob6iruHWvNfjGh1ofMxC3Jg_XBGxmBCTfiaVaBMrA33FgoCQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Patch for random mac address
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: HacKurx <hackurx@gmail.com>, kernel-hardening@lists.openwall.com, keescook@google.com
List-ID: <kernel-hardening.lists.openwall.com>

2017-05-25 0:40 GMT+02:00 Casey Schaufler <casey@schaufler-ca.com>:
>
> @@ -262,6 +262,10 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
>
>  case SIOCSIFHWADDR:
>  return dev_set_mac_address(dev, &ifr->ifr_hwaddr);
> +#ifdef CONFIG_RANDOM_MAC_ADDRESS
> + /* ignore userland MAC changes */
> + return 0;
> +#endif

I am not sure whether this code does what the comment advertises, but
I bet that Kali-like distro users still would like to be able to
change MAC, also such behavior should be documented in config section.
Thank you for your involvement, please take a look at this article
about preparing kernel patches in general (besides ml addresses most
of it could apply here as well):
https://www.kernel.org/doc/html/latest/process/submitting-patches.html

Thanks,
Lukas
