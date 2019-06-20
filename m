Date: Thu, 20 Jun 2019 09:15:46 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: Audit and fix all misuse of NLA_STRING: STATUS
Message-ID: <201906200913.D2698BD0@keescook>
References: <CABgxDoLSzkVJ7Vh8mLiZySz6uS+VEu+GUxRqX8EWHKQDyz2fSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgxDoLSzkVJ7Vh8mLiZySz6uS+VEu+GUxRqX8EWHKQDyz2fSg@mail.gmail.com>
To: Romain Perier <romain.perier@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 18, 2019 at 07:56:42PM +0200, Romain Perier wrote:
> Hi !
> 
> Here a first review, you can get the complete list here:
> 
> https://salsa.debian.org/rperier-guest/linux-tree/raw/next/STATUS

Cool! You identified three issues:

net/netfilter/nfnetlink_cthelper.c:
	NF_CT_HELPER_NAME_LEN is used instead of NF_CT_EXP_POLICY_NAME_LEN

net/netfilter/ipset/ip_set_list_set.c:
	IPSET_ATTR_NAME and IPSET_ATTR_NAMEREF both have a len of
	IPSET_MAXNAMELEN for a string of size IPSET_MAXNAMELEN

net/openvswitch/conntrack.c:
	maxlen of NF_CT_HELPER_NAME_LEN with a string of size
	NF_CT_HELPER_NAME_LEN. maxlen of CTNL_TIMEOUT_NAME_MAX with a
	string of size CTNL_TIMEOUT_NAME_MAX

I haven't looked closely at this myself yet, but I think the next step
would be to write patches for each of these. And while doing that, have
an eye toward thinking about how each case could be made more robust in
the future to avoid these kinds of flaws returning.

Nice!

-- 
Kees Cook
