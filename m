MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <8BCDD560-66F5-4CF7-97DD-E2E5BE1D13F4@nullcore.net>
References: <1515529383-35695-1-git-send-email-keescook@chromium.org>
 <CAGXu5jJjHd9D=20jYnx4PSJHBbRsUOP3bAOJ11yyUWutqVHr2A@mail.gmail.com> <8BCDD560-66F5-4CF7-97DD-E2E5BE1D13F4@nullcore.net>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 20 Jan 2018 17:22:07 -0800
Message-ID: <CAGXu5jLm_SO=WV1Wg6NJ6r4CZgiuut29awBAHXhvjRprOLYEWQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH 0/3] exec: Pin stack limit during exec
To: David Windsor <dave@nullcore.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Ben Hutchings <ben@decadent.org.uk>, Willy Tarreau <w@1wt.eu>, Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Rik van Riel <riel@redhat.com>, Laura Abbott <labbott@redhat.com>, Greg KH <greg@kroah.com>, Andy Lutomirski <luto@kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 19, 2018 at 5:12 PM, David Windsor <dave@nullcore.net> wrote:
> I have some spare cycles; is there any more relevant information outside of this thread?

Awesome, thanks! Context is in the other commits, but mainly I want to
double-check that nothing breaks with these changes, and that all the
races for changing stack rlimits during exec are fixed. And then, just
a sanity-check that the design approach to attaching the stack limit
to the bprm isn't crazy. :)

-Kees

>>> [1] 04e35f4495dd ("exec: avoid RLIMIT_STACK races with prlimit()")
>>> [2] 779f4e1c6c7c ("Revert "exec: avoid RLIMIT_STACK races with prlimit()"")
>>> [3] to security@kernel.org, "Subject: existing rlimit races?"



-- 
Kees Cook
Pixel Security
