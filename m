MIME-Version: 1.0
In-Reply-To: <20170602210544.73680be8@lxorguk.ukuu.org.uk>
References: <20170530132427.016053da@alans-desktop> <2ab8580e-bf8e-21bd-6bfa-33e5fa82400b@nmatt.com>
 <20170530235106.11aab25c@alans-desktop> <3bd4ff7b-6f7d-52b0-03f6-026bac79f11f@nmatt.com>
 <20170531005633.484a2e14@alans-desktop> <CAGXu5j+pqD1082fYDS_dvDB2QNvt9wSz+C7vAhGpMXcJWxoDkw@mail.gmail.com>
 <20170601140812.583cf0a5@alans-desktop> <CAGXu5jLefv=T3mCYryqh2pYjYonFsTQZSLsHqLK75CKvSmgb-w@mail.gmail.com>
 <20170601222432.6f593538@lxorguk.ukuu.org.uk> <2d0ad49c-886e-1caf-771a-d251957f614c@nmatt.com>
 <20170602153647.GA2688@mail.hallyn.com> <a3c1b792-a426-90e1-e37b-9f9a8d4d192a@nmatt.com>
 <20170602210544.73680be8@lxorguk.ukuu.org.uk>
From: Nick Kralevich <nnk@google.com>
Date: Fri, 2 Jun 2017 13:11:56 -0700
Message-ID: <CAFJ0LnFGRuEEn1tCLhoki8ZyWrKfktbF+rwwN7WzyC_kBFoQVA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/2] security: tty: make TIOCSTI
 ioctl require CAP_SYS_ADMIN
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Matt Brown <matt@nmatt.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kees Cook <keescook@chromium.org>, Casey Schaufler <casey@schaufler-ca.com>, Boris Lukashev <blukashev@sempervictus.com>, Greg KH <gregkh@linuxfoundation.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 2, 2017 at 1:05 PM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
> So I'd say it's all the generic tty ioctls except TIOCSTI and TIOCSETD
> but it would be good to see what Android is going with and why.

Android limits tty ioctls to the following whitelist:
  TIOCOUTQ
  FIOCLEX
  TCGETS
  TCSETS
  TIOCGWINSZ
  TIOCSWINSZ
  TIOCSCTTY
  TCSETSW
  TCFLSH
  TIOCSPGRP
  TIOCGPGRP

See unpriv_tty_ioctls at
https://android.googlesource.com/platform/system/sepolicy/+/34b4b73729b288b4109b2225c1445eb58393b8cb/public/ioctl_macros#51


-- 
Nick Kralevich | Android Security | nnk@google.com | 650.214.4037
