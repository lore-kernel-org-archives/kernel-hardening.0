Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sun, 28 Jan 2018 10:50:28 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20180128095027.hqrcpnholsvukdzd@gmail.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151703977742.26578.8362387033092864423.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151703977742.26578.8362387033092864423.stgit@dwillia2-desk3.amr.corp.intel.com>
Subject: [kernel-hardening] Re: [PATCH v5 12/12] x86/spectre: report get_user mitigation for
 spectre_v1
To: Dan Williams <dan.j.williams@intel.com>
Cc: tglx@linutronix.de, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, x86@kernel.org, torvalds@linux-foundation.org, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Jiri Slaby <jslaby@suse.cz>, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>


* Dan Williams <dan.j.williams@intel.com> wrote:

> Reflect the presence of 'get_user', '__get_user', and 'syscall'
> protections in sysfs. Keep the "Vulnerable" distinction given the
> expectation that the places that have been identified for 'array_idx'
> usage are likely incomplete.

(The style problems/inconsistencies of the previous patches are repeated here too, 
please fix.)

> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reported-by: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/x86/kernel/cpu/bugs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 390b3dc3d438..01d5ba48f745 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -269,7 +269,7 @@ ssize_t cpu_show_spectre_v1(struct device *dev,
>  {
>  	if (!boot_cpu_has_bug(X86_BUG_SPECTRE_V1))
>  		return sprintf(buf, "Not affected\n");
> -	return sprintf(buf, "Vulnerable\n");
> +	return sprintf(buf, "Vulnerable: Minimal user pointer sanitization\n");

Btw., I think this string is still somewhat passive-aggressive towards users, as 
it doesn't really give them any idea about what is missing from their system so 
that they can turn it into not vulnerable.

What else is missing that would turn this into a "Mitigated" entry?

Thanks,

	Ingo
