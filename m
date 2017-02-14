From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Mon, 13 Feb 2017 20:45:28 -0500
In-Reply-To: <alpine.LRH.2.20.1702131634000.8914@namei.org>
References: <alpine.LRH.2.20.1702131634000.8914@namei.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1487036728.15297.1.camel@linux.vnet.ibm.com>
Subject: [kernel-hardening] Re: [RFC PATCH 3/4] integrity: mark default IMA rules as
 __ro_after_init
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 2017-02-13 at 16:34 +1100, James Morris wrote:
> The default IMA rules are loaded during init and then do not
> change, so mark them as __ro_after_init.
> 
> Signed-off-by: James Morris <james.l.morris@oracle.com>

Thanks!

Mimi

> ---
>  security/integrity/ima/ima_policy.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index aed47b7..e8498a3 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -83,7 +83,7 @@ struct ima_rule_entry {
>   * normal users can easily run the machine out of memory simply building
>   * and running executables.
>   */
> -static struct ima_rule_entry dont_measure_rules[] = {
> +static struct ima_rule_entry dont_measure_rules[] __ro_after_init = {
>  	{.action = DONT_MEASURE, .fsmagic = PROC_SUPER_MAGIC, .flags = IMA_FSMAGIC},
>  	{.action = DONT_MEASURE, .fsmagic = SYSFS_MAGIC, .flags = IMA_FSMAGIC},
>  	{.action = DONT_MEASURE, .fsmagic = DEBUGFS_MAGIC, .flags = IMA_FSMAGIC},
> @@ -97,7 +97,7 @@ struct ima_rule_entry {
>  	{.action = DONT_MEASURE, .fsmagic = NSFS_MAGIC, .flags = IMA_FSMAGIC}
>  };
> 
> -static struct ima_rule_entry original_measurement_rules[] = {
> +static struct ima_rule_entry original_measurement_rules[] __ro_after_init = {
>  	{.action = MEASURE, .func = MMAP_CHECK, .mask = MAY_EXEC,
>  	 .flags = IMA_FUNC | IMA_MASK},
>  	{.action = MEASURE, .func = BPRM_CHECK, .mask = MAY_EXEC,
> @@ -108,7 +108,7 @@ struct ima_rule_entry {
>  	{.action = MEASURE, .func = FIRMWARE_CHECK, .flags = IMA_FUNC},
>  };
> 
> -static struct ima_rule_entry default_measurement_rules[] = {
> +static struct ima_rule_entry default_measurement_rules[] __ro_after_init = {
>  	{.action = MEASURE, .func = MMAP_CHECK, .mask = MAY_EXEC,
>  	 .flags = IMA_FUNC | IMA_MASK},
>  	{.action = MEASURE, .func = BPRM_CHECK, .mask = MAY_EXEC,
> @@ -122,7 +122,7 @@ struct ima_rule_entry {
>  	{.action = MEASURE, .func = POLICY_CHECK, .flags = IMA_FUNC},
>  };
> 
> -static struct ima_rule_entry default_appraise_rules[] = {
> +static struct ima_rule_entry default_appraise_rules[] __ro_after_init = {
>  	{.action = DONT_APPRAISE, .fsmagic = PROC_SUPER_MAGIC, .flags = IMA_FSMAGIC},
>  	{.action = DONT_APPRAISE, .fsmagic = SYSFS_MAGIC, .flags = IMA_FSMAGIC},
>  	{.action = DONT_APPRAISE, .fsmagic = DEBUGFS_MAGIC, .flags = IMA_FSMAGIC},
