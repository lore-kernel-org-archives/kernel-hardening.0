MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jLHps6z7nnwHwDv7kW9b21b4hPD_XmgKY1OjfNa0H-dKg@mail.gmail.com>
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
 <1497286620-15027-2-git-send-email-s.mesoraca16@gmail.com> <CAGXu5jLHps6z7nnwHwDv7kW9b21b4hPD_XmgKY1OjfNa0H-dKg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 27 Jun 2017 15:54:50 -0700
Message-ID: <CAGXu5jJ0LSPHZq9DZXhV-P8DWKwiZYuTEUvpxjkjWEWpnhT0cA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 01/11] S.A.R.A. Documentation
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 27, 2017 at 3:51 PM, Kees Cook <keescook@chromium.org> wrote:
> The USB Filtering of SARA seems kind of out of place. Does it have
> infrastructure in common with the WX protections? Should it be its own
> stackable LSM?

Oops, I was reading v1. I see USB has been dropped from v2 --
switching to reading the v2 now. :)

-Kees

-- 
Kees Cook
Pixel Security
