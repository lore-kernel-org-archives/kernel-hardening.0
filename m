MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1486511794-14490-1-git-send-email-dwindsor@gmail.com>
References: <1486511794-14490-1-git-send-email-dwindsor@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 7 Feb 2017 16:49:52 -0800
Message-ID: <CAGXu5jKVsT19LuN4qbs-x2oJjV=A7Z65p9K-4-PzMxPRrPWngg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] refcount: add refcount_t API kernel-doc comments
To: David Windsor <dwindsor@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, "Reshetova, Elena" <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 7, 2017 at 3:56 PM, David Windsor <dwindsor@gmail.com> wrote:
> This adds kernel-doc comments for the new refcount_t API.  Additional feature documentation can go in
> Documentation/security, if needed.

Very cool. This may need to get rebased to Peter's lastest series
(which uses REFCOUNT_WARN rather than WARN).

Please add a "Signed-off-by:" line as well.

I think it'd also be valuable to have some documentation describing
how to actually use these, similar to your Examples section on the
wiki.

-Kees

-- 
Kees Cook
Pixel Security
