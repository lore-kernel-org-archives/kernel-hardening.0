Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLsxwhrgyRfvYV79WJrrFr9tkXMe=7-qWBz6VWEsEA_5g@mail.gmail.com>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
	<CAGXu5jJJ13z206L6R99MYmiUA7hVYUJC5UVS8h5Mg0sUDr60GQ@mail.gmail.com>
	<CAGXu5jLsxwhrgyRfvYV79WJrrFr9tkXMe=7-qWBz6VWEsEA_5g@mail.gmail.com>
Date: Wed, 20 Jan 2016 08:11:58 -0500
Message-ID: <CAEXv5_iutxAv4HoWS5fbE+M7Di-6rhuAYTAD=Z-nJ2JAtxeS4A@mail.gmail.com>
From: David Windsor <dave@progbits.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening][RFC PATCH v2 00/12] Add PAX_REFCOUNT overflow protection
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

On Tue, Jan 19, 2016 at 2:07 PM, Kees Cook <keescook@chromium.org> wrote:
> Hi David,
>
> On Thu, Dec 17, 2015 at 12:55 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Thu, Dec 17, 2015 at 6:57 AM, David Windsor <dave@progbits.org> wrote:
>>> NOTE: This is a v2 submission because patch 3/5 in v1 was too large to sent
>>> to kernel-hardening.  Taking that as a sign that the patch needed to be split,
>>> I'm sending this version of the patchset, with the patches split more or less
>>> on a per-maintainer basis (except for those in drivers/).
>
> How's the next spin coming? It looks like we have some new real-world
> examples of exploits that would have been blocked by this protection:
>
> http://perception-point.io/2016/01/14/analysis-and-exploitation-of-a-linux-kernel-vulnerability-cve-2016-0728/
>
> :)
>

I'm currently working on v3 of this patchset: porting the patches to
linux-next and incorporating suggested changes to v2.  I'm fairly well
along, but need just a bit more time  I'm a bit busy at the moment, so
I expect realistically to have time to finish this at the beginning of
February.

Thanks,
David

> -Kees
>
> --
> Kees Cook
> Chrome OS & Brillo Security
