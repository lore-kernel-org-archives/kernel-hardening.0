Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
From: Kees Cook <keescook@chromium.org>
Date: Tue, 12 Jul 2016 18:17:31 -0400
Message-ID: <CAGXu5jKtompY1qznu45z+N0OgqbZ4P9RwBUjNSsLrXT=RoX=qg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Availability of gcc plugin headers on Debian and Ubuntu
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Matthias Klose <doko@debian.org>, Robo Bot <apw@canonical.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

For folks testing the gcc plugins on Debian, the latest gcc-5-cross
and gcc-6-cross sources were recently uploaded which adds the
plugin-dev packages for all the cross builds. That will make things
much easier to test. :)

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=826786

These will also be available in an Ubuntu update for Xenial (16.04)
once the proposed package testing period ends (a few more days, IIUC).

https://bugs.launchpad.net/ubuntu/+source/gcc-5/+bug/1586673

Thanks very much Matthias!

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
