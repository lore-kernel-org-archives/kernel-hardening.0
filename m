Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAFwXZv9Yb5o6Ms+U5P5cGfHzCfZpfgfTtHuZ0++ZmmBL8zG-zA@mail.gmail.com>
References: <99FC4B6EFCEFD44486C35F4C281DC6731F1DFFDA@ORSMSX107.amr.corp.intel.com>
	<CAFwXZv8qbWA5V_v4M2ayZM5WA7rxyVn9SYLN6fGVuvMUDLfKwA@mail.gmail.com>
	<99FC4B6EFCEFD44486C35F4C281DC6731F1E0062@ORSMSX107.amr.corp.intel.com>
	<CAFwXZv-5b4=G85CiDZXG7JvhWAee9A_wUrJHmc4O5wrDHO9fmg@mail.gmail.com>
	<34754.1449874747@turing-police.cc.vt.edu>
	<CAFwXZv9Yb5o6Ms+U5P5cGfHzCfZpfgfTtHuZ0++ZmmBL8zG-zA@mail.gmail.com>
Date: Sun, 13 Dec 2015 08:36:26 -0800
Message-ID: <CAGXu5jKMe3Jqsh_Aemd=14vePUV-3R4wB3Yjv4BHnPHXcr+XbA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Project convention on configuration options
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Dec 12, 2015 at 1:17 AM, HacKurx <hackurx@gmail.com> wrote:
> 2015-12-11 23:59 GMT+01:00  <Valdis.Kletnieks@vt.edu>:
>> But it's not clear that it's Intel's problem to support all of it by
>> itself, and the CII can only do sponsorship to the level that they themselves
>> have funding...
>
> But so far they know sell (Intel IoT Gateway, Intel MPX, Wind River and more)
>
> http://www.intel.com/content/dam/www/public/us/en/documents/white-papers/iot-security-profiles-white-paper.pdf
> http://www.intel.com/content/dam/www/public/us/en/documents/guides/wind-river-idp-xt2-programmers-guide.pdf
> https://communities.intel.com/community/itpeernetwork/blog/2015/03/16/intel-gateway-solution-is-at-the-center-of-internet-of-things-deployments
> https://software.intel.com/sites/default/files/IoT%20Gateway%20IDP%20XT%20GSG.pdf
> http://www.intel.com/content/dam/www/public/us/en/documents/research/2014-vol18-iss-4-intel-technology-journal.pdf

Intel's use of grsecurity in their products isn't something we can
meaningfully address on this mailing list.

As outlined on the wiki, and in my other posts, our focus here is on
bringing modern kernel self-protection technologies to upstream where
everyone can benefit from them.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
