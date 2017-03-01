MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170228160607.183a88bd491e97fa6a7ded9c@linux-foundation.org>
References: <476DC76E7D1DF2438D32BFADF679FC562307BAE6@ORSMSX103.amr.corp.intel.com>
 <163a690510e636a23187c0dc9caa09ddac6d4cde.1488228427.git.joe@perches.com> <20170228160607.183a88bd491e97fa6a7ded9c@linux-foundation.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 28 Feb 2017 16:11:46 -0800
Message-ID: <CAGXu5j+dZvZPnmWMVsgSL706m_mR+h7FGd1HS4TgKmXhYhA4Hw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH] checkpatch: Add ability to find
 bad uses of vsprintf %p<foo> extensions
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>, "Roberts, William C" <william.c.roberts@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 28, 2017 at 4:06 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 27 Feb 2017 12:54:55 -0800 Joe Perches <joe@perches.com> wrote:
>
>> %pK was at least once misused at %pk in an out-of-tree module.
>> This lead to some security concerns.  Add the ability to track
>> single and multiple line statements for misuses of %p<foo>.
>
> Should we also do this?

Ah yes, good idea. Maybe "...when adding/removing new conversion..." ?

-Kees

>
> --- a/lib/vsprintf.c~checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix
> +++ a/lib/vsprintf.c
> @@ -1477,6 +1477,9 @@ int kptr_restrict __read_mostly;
>   * by an extra set of alphanumeric characters that are extended format
>   * specifiers.
>   *
> + * Please update scripts/checkpatch.pl when adding new conversion characters.
> + * (search for "check for vsprintf extension").
> + *
>   * Right now we handle:
>   *
>   * - 'F' For symbolic function descriptor pointers with offset
> _
>



-- 
Kees Cook
Pixel Security
