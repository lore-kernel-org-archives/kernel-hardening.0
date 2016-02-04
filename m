Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAEXv5_juGN8QxJ6jB7-1WGB7BN1-G0bUxKyD-zeCjsK4d29uzw@mail.gmail.com>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
	<CAGXu5jJJ13z206L6R99MYmiUA7hVYUJC5UVS8h5Mg0sUDr60GQ@mail.gmail.com>
	<CAGXu5jLsxwhrgyRfvYV79WJrrFr9tkXMe=7-qWBz6VWEsEA_5g@mail.gmail.com>
	<CAEXv5_iutxAv4HoWS5fbE+M7Di-6rhuAYTAD=Z-nJ2JAtxeS4A@mail.gmail.com>
	<CAEXv5_juGN8QxJ6jB7-1WGB7BN1-G0bUxKyD-zeCjsK4d29uzw@mail.gmail.com>
Date: Thu, 4 Feb 2016 10:19:55 -0800
Message-ID: <CAGXu5jKfe8=wmL6VFqFB8jR2pzS9EWp7Mwrt4XAEYbWcjLdjnQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening][RFC PATCH v2 00/12] Add PAX_REFCOUNT overflow protection
To: David Windsor <dave@progbits.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 2, 2016 at 3:33 AM, David Windsor <dave@progbits.org> wrote:
> FYI, I now have time to work on this again.
>
> Currently, I'm rebasing v2 atop linux-next.  I've already incorporated
> the following changes suggested during the on-list review of v2:
>
> * s/PAX_REFCOUNT/STRICT_REFCOUNT
> * Reordering the patchset in a more sane manner (per Greg KH)
> * Creation of the "Kernel Hardening" menu in Kconfig
> * Creation of per-architecture Kconfig option for opting in to STRICT_REFCOUNT
> * Whitespace fixes
>
> v3 is forthcoming and will be posted here as soon as I have the
> patchset rebased to linux-next.

Thanks for the update!

It may be helpful to mention in the changelog the two recent refcount
overflow bugs that would have been stopped by this mitigiation:

CVE-2014-2851 https://cyseclabs.com/page?n=02012016
CVE-2016-0728 http://perception-point.io/2016/01/14/analysis-and-exploitation-of-a-linux-kernel-vulnerability-cve-2016-0728/

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
