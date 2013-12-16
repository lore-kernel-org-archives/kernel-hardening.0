Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1387133834-31966-1-git-send-email-tixxdz@opendz.org>
References: <1387133834-31966-1-git-send-email-tixxdz@opendz.org>
Date: Mon, 16 Dec 2013 09:36:27 -0800
Message-ID: <CAGXu5jKqdHPDXDrh4sMUNd+ihuJHKwSbygVOHET6cDer7VnN=A@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [Resend] [PATCH 0/2] procfs: make /proc/*/{stack,syscall,pagemap} 0400
To: Djalal Harouni <tixxdz@opendz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Dec 15, 2013 at 10:57 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> The following patches make /proc/*/{stack,syscall,personality,pagemap}
> 0400.

Yes, please! This greatly reduces the scope of the leak problem (with
0400 the leak is possible only if an attacker can spawn the target
setuid process, instead of being able to leak from an already running
one).

-Kees

-- 
Kees Cook
Chrome OS Security
