using Quartz;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Ecompliance.Utils
{
    public class TestScheduler : IJob
    {
        public void Execute(IJobExecutionContext context)
        {
            int i = 0;
            int j = 1;
        }
    }
}