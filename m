MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1497286620-15027-2-git-send-email-s.mesoraca16@gmail.com>
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com> <1497286620-15027-2-git-send-email-s.mesoraca16@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 27 Jun 2017 15:51:35 -0700
Message-ID: <CAGXu5jLHps6z7nnwHwDv7kW9b21b4hPD_XmgKY1OjfNa0H-dKg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 01/11] S.A.R.A. Documentation
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 12, 2017 at 9:56 AM, Salvatore Mesoraca
<s.mesoraca16@gmail.com> wrote:
> Adding documentation for S.A.R.A. LSM.
>
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
> ---
>  Documentation/admin-guide/kernel-parameters.txt |  40 +++++
>  Documentation/security/00-INDEX                 |   2 +
>  Documentation/security/SARA.rst                 | 192 ++++++++++++++++++++++++
>  3 files changed, 234 insertions(+)
>  create mode 100644 Documentation/security/SARA.rst
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 0f5c3b4..f3ee12d 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -3702,6 +3702,46 @@
>                         1 -- enable.
>                         Default value is set via kernel config option.
>
> +       sara=           [SARA] Disable or enable S.A.R.A. at boot time.
> +                       If disabled this way S.A.R.A. can't be enabled
> +                       again.
> +                       Format: { "0" | "1" }
> +                       See security/sara/Kconfig help text
> +                       0 -- disable.
> +                       1 -- enable.
> +                       Default value is set via kernel config option.
> +
> +       sara_usb_filtering= [SARA]
> +                       Disable or enable S.A.R.A. USB Filtering at boot
> +                       time.
> +                       Format: { "0" | "1" }
> +                       See security/sara/Kconfig help text
> +                       0 -- disable.
> +                       1 -- enable.
> +                       Default value is 1.
> +
> +       sara_usb_filtering_default= [SARA]
> +                       Set S.A.R.A. USB Filtering default action.
> +                       Format: { "a" | "d" }
> +                       See security/sara/Kconfig help text
> +                       a -- allow.
> +                       d -- deny.
> +                       Default value is set via kernel config option.
> +
> +       sara_wxprot=    [SARA] Disable or enable S.A.R.A. WX Protection
> +                       at boot time.
> +                       Format: { "0" | "1" }
> +                       See security/sara/Kconfig help text
> +                       0 -- disable.
> +                       1 -- enable.
> +                       Default value is 1.
> +
> +       sara_wxprot_default_flags= [SARA]
> +                       Set S.A.R.A. WX Protection default flags.
> +                       Format: <integer>
> +                       See S.A.R.A. documentation.
> +                       Default value is set via kernel config option.
> +

As an organizational note, I would suggest making these all regular
"module parameters", which would let them be automatically namespaced
under "sara". For example "sara.enabled", "sara.wxprot", etc. For
example, this is how LoadPin does it for "loadpin.enabled":

/* Should not be mutable after boot, so not listed in sysfs (perm == 0). */
module_param(enabled, int, 0);
MODULE_PARM_DESC(enabled, "Pin module/firmware loading (default: true)");

> +S.A.R.A. (S.A.R.A. is Another Recursive Acronym) is a stacked Linux Security
> +Module that aims to collect heterogeneous security measures, providing a common
> +interface to manage them.
> +As of today it consists of two main submodules:
> +
> +- USB Filtering
> +- WX Protection

The USB Filtering of SARA seems kind of out of place. Does it have
infrastructure in common with the WX protections? Should it be its own
stackable LSM?

-Kees

-- 
Kees Cook
Pixel Security
