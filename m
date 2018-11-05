Subject: Re: [PATCH v6 5/5] sidechannel: Linux Security Module for sidechannel
References: <20181105190504.500-1-casey.schaufler@intel.com>
 <20181105190504.500-6-casey.schaufler@intel.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <35bac572-14cc-d7c3-f788-1120c7431fb4@infradead.org>
Date: Mon, 5 Nov 2018 11:52:08 -0800
MIME-Version: 1.0
In-Reply-To: <20181105190504.500-6-casey.schaufler@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Casey Schaufler <casey.schaufler@intel.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, dave.hansen@intel.com, deneen.t.dock@intel.com, kristen@linux.intel.com, arjan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi:

On 11/5/18 11:05 AM, Casey Schaufler wrote:
> diff --git a/security/sidechannel/Kconfig b/security/sidechannel/Kconfig
> new file mode 100644
> index 000000000000..653033027415
> --- /dev/null
> +++ b/security/sidechannel/Kconfig
> @@ -0,0 +1,13 @@
> +config SECURITY_SIDECHANNEL
> +	bool "Sidechannel attack safety extra checks"
> +	depends on SECURITY
> +	default n

Please drop the "default n" since it is already the default value.

> +	help
> +	  Look for a variety of cases where a side-channel attack
> +	  could potentially be exploited. Instruct the switching
> +	  code to use the indirect_branch_prediction_barrier in
> +	  cases where the passed task and the current task may be
> +	  at risk.
> +
> +          If you are unsure how to answer this question, answer N.

Use tab + 2 spaces to indent the line above.
> +

thanx.
-- 
~Randy
