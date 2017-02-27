MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <163a690510e636a23187c0dc9caa09ddac6d4cde.1488228427.git.joe@perches.com>
References: <476DC76E7D1DF2438D32BFADF679FC562307BAE6@ORSMSX103.amr.corp.intel.com>
 <163a690510e636a23187c0dc9caa09ddac6d4cde.1488228427.git.joe@perches.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 27 Feb 2017 13:18:14 -0800
Message-ID: <CAGXu5jL7yxWQ=0uG6SwDnXAxFytkso1kDKGAGN81FBnyd2qSXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH] checkpatch: Add ability to find bad
 uses of vsprintf %p<foo> extensions
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andy Whitcroft <apw@canonical.com>, "Roberts, William C" <william.c.roberts@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 27, 2017 at 12:54 PM, Joe Perches <joe@perches.com> wrote:
> %pK was at least once misused at %pk in an out-of-tree module.
> This lead to some security concerns.  Add the ability to track
> single and multiple line statements for misuses of %p<foo>.
>
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>
> Andrew, this has gone back and forth a few times.
>
> It's imperfect as a patch context with just a single
> function addition can be missed, but that's not new
> with $stat tests and just this patch.  Perhaps one day
> the $stat identification mechanism can be improved.
>
> Until then, can you please apply this?  Thanks.
>
>  scripts/checkpatch.pl | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index ad5ea5c545b2..9293b8a1c121 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -5676,6 +5676,32 @@ sub process {
>                         }
>                 }
>
> +               # check for vsprintf extension %p<foo> misuses
> +               if ($^V && $^V ge 5.10.0 &&
> +                   defined $stat &&
> +                   $stat =~ /^\+(?![^\{]*\{\s*).*\b(\w+)\s*\(.*$String\s*,/s &&
> +                   $1 !~ /^_*volatile_*$/) {
> +                       my $bad_extension = "";
> +                       my $lc = $stat =~ tr@\n@@;
> +                       $lc = $lc + $linenr;
> +                       for (my $count = $linenr; $count <= $lc; $count++) {
> +                               my $fmt = get_quoted_string($lines[$count - 1], raw_line($count, 0));
> +                               $fmt =~ s/%%//g;
> +                               if ($fmt =~ /(\%[\*\d\.]*p(?![\WFfSsBKRraEhMmIiUDdgVCbGN]).)/) {
> +                                       $bad_extension = $1;
> +                                       last;
> +                               }
> +                       }
> +                       if ($bad_extension ne "") {
> +                               my $stat_real = raw_line($linenr, 0);
> +                               for (my $count = $linenr + 1; $count <= $lc; $count++) {
> +                                       $stat_real = $stat_real . "\n" . raw_line($count, 0);
> +                               }
> +                               WARN("VSPRINTF_POINTER_EXTENSION",
> +                                    "Invalid vsprintf pointer extension '$bad_extension'\n" . "$here\n$stat_real\n");
> +                       }
> +               }
> +
>  # Check for misused memsets
>                 if ($^V && $^V ge 5.10.0 &&
>                     defined $stat &&
> --
> 2.10.0.rc2.1.g053435c
>



-- 
Kees Cook
Pixel Security
