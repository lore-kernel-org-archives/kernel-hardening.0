Date: Fri, 16 Jun 2017 10:25:44 +0800
From: kbuild test robot <lkp@intel.com>
Message-ID: <201706161000.YdVELEbH%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170608034349.31876-2-matt@nmatt.com>
Subject: [kernel-hardening] Re: [PATCH v2 1/1] Add Trusted Path Execution as a stackable LSM
To: Matt Brown <matt@nmatt.com>
Cc: kbuild-all@01.org, james.l.morris@oracle.com, serge@hallyn.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Matt,

[auto build test WARNING on security/next]
[also build test WARNING on v4.12-rc5 next-20170615]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Matt-Brown/Add-Trusted-Path-Execution-as-a-stackable-LSM/20170609-115004
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> security/tpe/tpe_lsm.c:45:5: sparse: symbol 'print_tpe_error' was not declared. Should it be static?
>> security/tpe/tpe_lsm.c:128:5: sparse: symbol 'tpe_mmap_file' was not declared. Should it be static?
>> security/tpe/tpe_lsm.c:137:5: sparse: symbol 'tpe_file_mprotect' was not declared. Should it be static?
>> security/tpe/tpe_lsm.c:160:17: sparse: symbol 'tpe_sysctl_path' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
