Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 13 Jul 2016 07:38:57 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
Message-ID: <20160712233857.GE17537@wfg-t540p.sh.intel.com>
References: <CAGXu5jKtompY1qznu45z+N0OgqbZ4P9RwBUjNSsLrXT=RoX=qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAGXu5jKtompY1qznu45z+N0OgqbZ4P9RwBUjNSsLrXT=RoX=qg@mail.gmail.com>
Subject: [kernel-hardening] Re: Availability of gcc plugin headers on Debian and Ubuntu
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Matthias Klose <doko@debian.org>, Robo Bot <apw@canonical.com>
List-ID: <kernel-hardening.lists.openwall.com>

Kudos to Matthias!

We'll upgrade once they landed Debian sid.

Thanks,
Fengguang

On Tue, Jul 12, 2016 at 06:17:31PM -0400, Kees Cook wrote:
>Hi,
>
>For folks testing the gcc plugins on Debian, the latest gcc-5-cross
>and gcc-6-cross sources were recently uploaded which adds the
>plugin-dev packages for all the cross builds. That will make things
>much easier to test. :)
>
>https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=826786
>
>These will also be available in an Ubuntu update for Xenial (16.04)
>once the proposed package testing period ends (a few more days, IIUC).
>
>https://bugs.launchpad.net/ubuntu/+source/gcc-5/+bug/1586673
>
>Thanks very much Matthias!
>
>-Kees
>
>-- 
>Kees Cook
>Chrome OS & Brillo Security
